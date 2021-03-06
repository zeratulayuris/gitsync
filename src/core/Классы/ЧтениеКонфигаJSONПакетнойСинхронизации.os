﻿
#Использовать json

Перем мНастройки;
Перем СоответствиеКлючамИПараметра;

Процедура ПриСозданииОбъекта(ВходящиеСоответствиеКлючамИПараметра)

	СоответствиеКлючамИПараметра = ВходящиеСоответствиеКлючамИПараметра;
	
КонецПроцедуры

Функция ПрочитатьФайл(Знач ИмяФайла)
	ФайлСуществующий = Новый Файл(ИмяФайла);
	Если Не ФайлСуществующий.Существует() Тогда
		ВызватьИсключение "Неверная структура файла настроек / файл пустой";;
	КонецЕсли;

	Чтение = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
	Рез  = Чтение.Прочитать();
	Чтение.Закрыть();
	Возврат Рез;
КонецФункции // ПрочитатьФайл()

Функция ПрочитатьНастройкиИзФайла(Знач ФайлНастроек) Экспорт
	
	мНастройки = Новый Структура;
	
	JsonСтрока  = ПрочитатьФайл(ФайлНастроек);
	
	ПарсерJSON  = Новый ПарсерJSON();
	ПараметрыJSON = ПарсерJSON.ПрочитатьJSON(JsonСтрока);

	ВсеНастройки = ПараметрыJSON["gitsync-options"];
	ГлобальныеНастройки = ВсеНастройки["global"];
	
	Для Каждого КлючИЗначение Из ГлобальныеНастройки Цикл
		Ключ = СоответствиеКлючамИПараметра[КлючИЗначение.Ключ];

		Если НЕ Ключ = Неопределено Тогда
				мНастройки.Вставить(Ключ, КлючИЗначение.Значение);
		КонецЕсли;

	КонецЦикла;
	
	мНастройки.Вставить("Репозитарии", Новый Массив);
	
	МассивРепозиториев = ВсеНастройки["repositories"];
	
	Для Каждого Репозиторий Из МассивРепозиториев Цикл
		
		ПрочитатьНастройкиРепозитория(Репозиторий);
		
	КонецЦикла;
	
	Возврат мНастройки;
	
КонецФункции

Процедура ПрочитатьНастройкиРепозитория(Знач СтруктураНастроекРепозитория )
	
	Репо = Новый Структура;
	
	мНастройки.Репозитарии.Добавить(Репо);
	
	Для Каждого КлючИЗначение Из СтруктураНастроекРепозитория Цикл

		Ключ = СоответствиеКлючамИПараметра[КлючИЗначение.Ключ];
			
		Если НЕ Ключ = Неопределено Тогда
			Репо.Вставить(Ключ, КлючИЗначение.Значение);
		КонецЕсли;
		
	КонецЦикла;

	Для Каждого ГлобальнаяНастройка Из мНастройки Цикл

		Ключ = ГлобальнаяНастройка.Ключ;

		Если ГлобальнаяНастройка.Ключ  = "Репозитарии" Тогда
			Продолжить
		КонецЕсли;
		
		ЕстьСвояНастройка = Репо.Свойство(Ключ);

		Если НЕ ЕстьСвояНастройка 
			ИЛИ ЕстьСвояНастройка и ПустаяСтрока(Репо[Ключ]) Тогда
		
			Репо.Вставить(Ключ, ГлобальнаяНастройка.Значение);
		КонецЕсли;

	КонецЦикла

КонецПроцедуры

Функция СтрокаНекорректнаяСтруктураНастроек()
	Возврат "Некорректная структура файла настроек";
КонецФункции
