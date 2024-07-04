#Область СлужебныеПроцедурыИФункции

// Процедура по заданным значениям реквизитов перезаполняет
// данными табличную часть
//
// Параметры
//  НЕТ
// Возвращаемые значения
//  НЕТ
Процедура ОбновитьТаблицу() Экспорт

	ТаблицаРасстояний.Очистить();
	
	Если ЗначениеЗаполнено(Пункт)Тогда
		
		Запрос = Новый Запрос();

		Запрос.УстановитьПараметр("Пункт" , Пункт);

		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР КОГДА уатРасстоянияМеждуПунктами.Пункт1 = &Пункт ТОГДА уатРасстоянияМеждуПунктами.Пункт2 ИНАЧЕ уатРасстоянияМеждуПунктами.Пункт1 КОНЕЦ КАК Пункт,
		               |	уатРасстоянияМеждуПунктами.Расстояние,
		               |	уатРасстоянияМеждуПунктами.Время
		               |ИЗ
		               |	РегистрСведений.уатРасстоянияМеждуПунктами КАК уатРасстоянияМеждуПунктами
		               |
		               |ГДЕ
		               |	(уатРасстоянияМеждуПунктами.Пункт1 = &Пункт ИЛИ уатРасстоянияМеждуПунктами.Пункт2 = &Пункт)";

		ТаблицаРасстояний.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура обрабатывает действие удаления
// записи контактной информации
//
// Параметры
//  ВыбОбъект - объект уже существующей записи в регистре контактной информации
//  ВыбТип - тип уже существующей или новой записи в регистре контактной информации
//  ВыбВид - вид уже существующей или новой записи в регистре контактной информации
// Возвращаемые значения
//  НЕТ
Процедура УдалитьЗапись(ВыбОбъект, ТекущийОбъект) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.уатРасстоянияМеждуПунктами.СоздатьМенеджерЗаписи();
	
	Если (уатОбщегоНазначения.уатЗначениеНеЗаполнено(ВыбОбъект)) или (уатОбщегоНазначения.уатЗначениеНеЗаполнено(ТекущийОбъект)) Тогда
		// Выбрали запись, которой еще нет в регистре
		Возврат;
	Иначе
		МенеджерЗаписи.Пункт1 = ВыбОбъект;
		МенеджерЗаписи.Пункт2 = ТекущийОбъект;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Удалить();
		Иначе
			МенеджерЗаписи.Пункт2 = ВыбОбъект;
			МенеджерЗаписи.Пункт1 = ТекущийОбъект;
			МенеджерЗаписи.Прочитать();
			
			Если МенеджерЗаписи.Выбран() Тогда
				МенеджерЗаписи.Удалить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
