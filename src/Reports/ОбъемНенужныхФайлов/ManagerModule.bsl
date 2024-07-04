///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОбъемНенужныхФайловПоВладельцам");
	НастройкиВарианта.Описание = НСтр("ru = 'Позволяет получить информацию об объеме данных, занятых ненужными файлами.'; en = 'Provides information about data amount occupied by unnecessary files.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу ненужных файлов.
//
// Возвращаемое значение:
//   ТаблицаЗначений:
//   * ВладелецФайла - ОпределяемыйТип.ВладелецФайлов
//   * ОбъемНенужныхФайлов - Число
//
Функция ТаблицаНенужныхФайлов() Экспорт
	
	НастройкиОчистки = РегистрыСведений.НастройкиОчисткиФайлов.ТекущиеНастройкиОчистки();
	
	ТаблицаНенужныхФайлов = Новый ТаблицаЗначений;
	ТаблицаНенужныхФайлов.Колонки.Добавить("ВладелецФайла");
	ТаблицаНенужныхФайлов.Колонки.Добавить("ОбъемНенужныхФайлов", Новый ОписаниеТипов("Число"));
	
	НастройкиОчисткиФайлов  = НастройкиОчистки.НайтиСтроки(Новый Структура("ЭтоНастройкаДляЭлементаСправочника", Ложь));
	
	Для Каждого Настройка Из НастройкиОчисткиФайлов Цикл
		
		МассивИсключений = Новый Массив;
		ДетализированныеНастройки = НастройкиОчистки.НайтиСтроки(Новый Структура(
			"ИдентификаторВладельца, ЭтоНастройкаДляЭлементаСправочника",
			Настройка.ВладелецФайла,
			Истина));
		Если ДетализированныеНастройки.Количество() > 0 Тогда
			Для Каждого ЭлементИсключение Из ДетализированныеНастройки Цикл
				МассивИсключений.Добавить(ЭлементИсключение.ВладелецФайла);
				ДополнитьТаблицуНенужныхФайлов(ТаблицаНенужныхФайлов, ЭлементИсключение, МассивИсключений);
			КонецЦикла;
		КонецЕсли;
		
		ДополнитьТаблицуНенужныхФайлов(ТаблицаНенужныхФайлов, Настройка, МассивИсключений);
	КонецЦикла;
	
	Возврат ТаблицаНенужныхФайлов;
	
КонецФункции

Процедура ДополнитьТаблицуНенужныхФайлов(ТаблицаНенужныхФайлов, НастройкаОчистки, МассивИсключений)
	
	Если НастройкаОчистки.Действие = Перечисления.ВариантыОчисткиФайлов.НеОчищать Тогда
		Возврат;
	КонецЕсли;
	
	Если МассивИсключений = Неопределено Тогда
		МассивИсключений = Новый Массив;
	КонецЕсли;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаЗначений);
	НенужныеФайлы = РаботаСФайламиСлужебный.ВыбратьДанныеПоПравилу(НастройкаОчистки, МассивИсключений, ПроцессорВывода);
	
	Для Каждого НенужныйФайл Из НенужныеФайлы Цикл
		НоваяСтрока = ТаблицаНенужныхФайлов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, НенужныйФайл);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли