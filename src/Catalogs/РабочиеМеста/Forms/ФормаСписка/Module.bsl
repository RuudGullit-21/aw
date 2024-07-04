
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущееРабочееМесто = МенеджерОборудованияКлиентПовтИсп.РабочееМестоКлиента();
	Список.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", ТекущееРабочееМесто); 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ИдентификаторКлиента = МенеджерОборудованияКлиентСервер.ИдентификаторКлиентаДляРабочегоМеста();
	РабочееМесто = ПолучитьРабочееМестоПоИдентификаторуКлиента(ИдентификаторКлиента);
	
	Если НЕ РабочееМесто = Неопределено Тогда
		
		Отказ = Истина;
			                  
		Текст = НСтр("ru = 'Создание нового рабочего места не требуется. "
"Для данного идентификатора клиента оно уже создано."
"Открыть существующее рабочее место?'; en = 'It is not required to create a new work place."
"It is already created for this client ID."
"Open the existing work place?'");
		Оповещение = Новый ОписаниеОповещения("СписокПередНачаломДобавленияЗавершение", ЭтотОбъект, РабочееМесто);
		ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры  

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СписокПередНачаломДобавленияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да И Не ПустаяСтрока(Параметры) Тогда
		ПоказатьЗначение(, Параметры);
	КонецЕсли;  
	
КонецПроцедуры 

&НаСервере
Функция ПолучитьРабочееМестоПоИдентификаторуКлиента(Идентификатор)
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|    РабочиеМеста.Ссылка
	|ИЗ
	|    Справочник.РабочиеМеста КАК РабочиеМеста
	|ГДЕ
	|    РабочиеМеста.Код = &Идентификатор");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти